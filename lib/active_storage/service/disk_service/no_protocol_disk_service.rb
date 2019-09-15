require "active_storage/service/disk_service"
module ActiveStorage
  class Service::NoProtocolDiskService < Service::DiskService
    def url(key, *options)
      super(key, *options).gsub /http(s)?:/, ''
    end
  end
end