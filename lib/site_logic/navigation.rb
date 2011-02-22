module SiteLogic

  class Navigation

    attr_accessor :kind
    attr_accessor :label
    attr_accessor :description

    def initialize(args)
      args.each{|k,v| self.send("#{k}=",v) if self.respond_to?(k)}
    end

  end

end