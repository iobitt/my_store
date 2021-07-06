class ApplicationService
  def self.call(*args, &block)
    return new(*args, &block).call
  end
end
