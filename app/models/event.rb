# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_active       :boolean          default(TRUE)
#  comment         :boolean          default(FALSE)
#  flagged         :boolean          default(FALSE)
#  post_con        :boolean          default(FALSE)
#  quote           :boolean          default(FALSE)
#  sticky          :boolean          default(FALSE)
#  emergency       :boolean          default(FALSE)
#  medical         :boolean          default(FALSE)
#  hidden          :boolean          default(FALSE)
#  secure          :boolean          default(FALSE)
#  consuite        :boolean
#  hotel           :boolean
#  parties         :boolean
#  volunteers      :boolean
#  dealers         :boolean
#  dock            :boolean
#  merchandise     :boolean
#  merged_from_ids :string(255)
#  merged          :boolean
#  nerf_herders    :boolean
#

require Rails.root + 'app/queries/event_queries'


class Event < ActiveRecord::Base
  include PgSearch
  include Queries::EventQueries

  audited
  has_associated_audits
  serialize :merged_from_ids

  has_many :entries, dependent: :destroy, order: 'created_at ASC'
  has_many :event_flag_histories, dependent: :destroy, order: 'created_at ASC'
  validates_associated :entries
  accepts_nested_attributes_for :entries, allow_destroy: true

  attr_accessible :is_active, :comment, :flagged, :post_con, :quote, :sticky, :emergency,
                  :medical, :hidden, :secure, :consuite, :hotel, :parties, :volunteers,
                  :dealers, :dock, :merchandise, :nerf_herders, :status

  paginates_per 10

  pg_search_scope :search_entries, using: { tsearch: { prefix: true } },
                  associated_against:     {
                      entries: :description
                  }

  scope :actives_and_stickies_or_all, lambda { |c| where { |e| (e.is_active == true) | (e.sticky == true) unless c } }

  scope :protect_sensitive_events, lambda { |user|
    where { |e| (e.hidden == false unless user_can_see_hidden(user)) }.
        where { |e| (e.secure == false unless user_can_rw_secure(user)) }
  }

  STATUSES = %w[ Active Closed Merged ]
  FLAGS    = %w[ is_active merged comment flagged post_con quote sticky emergency medical hidden secure consuite hotel parties volunteers dealers dock merchandise nerf_herders ]

  def self.search(q, user, show_closed=false)
    protect_sensitive_events(user).
        actives_and_stickies_or_all(show_closed).
        search_entries(q)
  end

  def self.merge_events(event_ids, user, role_name = nil)
    return if event_ids.blank?

    new_event = Event.create! do |new_event|
      new_event.merged_from_ids = event_ids
    end

    new_event.merge_entries event_ids
    new_event.merge_flags event_ids
    new_event.add_entry "Merged by #{user.username} as '#{role_name}' from #{event_ids.join(', ')}", user.id, role_name
    new_event.save!
    new_event.reload
  end

  def self.user_can_see_hidden(user)
    return user != nil ? user.read_hidden_entries? : false
  end

  def self.user_can_rw_secure(user)
    return user != nil ? user.rw_secure? : false
  end

  def self.num_active
    return Event.where { is_active == true }.count
  end

  def self.num_inactive
    return Event.where { is_active != true }.count
  end

  def self.num_active_emergencies
    return Event.where { (is_active == true) & (emergency == true) }.count
  end

  def self.num_active_medicals
    return Event.where { (is_active == true) & (medical == true) }.count
  end

  def add_entry(description, user_id, rolename = nil)
    self.entries << Entry.new do |new_entry|
      new_entry.description = description
      new_entry.user_id     = user_id
      new_entry.rolename    = rolename
    end
  end

  def flags_differ?(params)
    params.each do |p|
      return true if p.first == "status" and p.second != self.status
      return true if p.first != "status" and
          self[p.first] != ((p.last == "1" or p.last == true) ? true : false)
    end
    false
  end

  def flags # Note: always returns FALSE for NIL
    FLAGS.inject(HashWithIndifferentAccess.new) do |map, flag|
      map[flag.to_sym] = (self.send(flag).presence || false)
      map
    end
  end

  def flags=(new_flags)
    new_flags.each do |flag, val|
      self[flag] = val
    end
  end

  def merge_flags(event_ids)
    Event.where { id >> event_ids }.find_each do |ev|
      self.flags = Event.flags_union(self.flags, ev.flags)
      ev.set_and_save_status 'Merged'
    end
  end

  def self.flags_union(a, b)
    FLAGS.inject(HashWithIndifferentAccess.new) do |map, flag|
      map[flag.to_sym] = a[flag] | b[flag]
      map
    end
  end

  def merge_entries(event_ids)
    Entry.where { |e| e.event_id >> event_ids }.order('created_at ASC').find_each do |entry|
      new_entry            = entry.dup
      new_entry.created_at = entry.created_at
      self.entries << new_entry
    end
  end

  def status
    return 'Merged' if merged?
    return 'Active' if is_active?
    return 'Closed' unless is_active?
  end

  def status=(string)
    case string
      when 'Active'
        self.is_active = true
        self.merged    = false
      when 'Closed'
        self.is_active = false
        self.merged    = false
      when 'Merged'
        self.is_active = false
        self.merged    = true
      else
        raise Exception
    end
  end

  def set_and_save_status(string)
    self.status = string
    self.save!
  end

  def self.statuses
    return STATUSES
  end

  def self.flags
    return FLAGS
  end

  protected



end
