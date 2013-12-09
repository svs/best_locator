class Trip < ActiveRecord::Base

  belongs_to :user
  has_many :location_reports

  belongs_to :start_stop, :class_name => Stop
  belongs_to :end_stop, :class_name => Stop

  validates_presence_of :user_id

  def self.live
    where(:status => "started")
  end

  def start!
    return false unless startable?
    self.status = "started"
    self.started_at = Time.zone.now
    self.save
  end

  def stop!
    return false unless stoppable?
    self.status = "stopped"
    self.ended_at = Time.zone.now
    self.save
  end

  def fresh?
    status == "new"
  end

  def startable?
    fresh?
  end

  def started?
    status == "started"
  end

  def stoppable?
    started?
  end

  def stopped?
    status == "stopped"
  end


end
