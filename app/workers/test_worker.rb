class TestWorker < BaseWorker
  def perform(*args)
    p "Executed #{self.class.name} finished!"
  end
end