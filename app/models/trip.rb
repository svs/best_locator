class Trip < ActiveRecord::Base

  belongs_to :user
  has_many :location_reports

  validates_presence_of :user_id

  def start!
    return false unless startable?
    self.status = "started"
    self.save
  end

  def stop!
    return false unless stoppable?
    self.status = "stopped"
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
