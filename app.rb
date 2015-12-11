class App
  def call(env)
    Rack::Request.send :define_method, :action do
      dev? ? path_split[2] : path_split[1]
    end

    Rack::Request.send :define_method, :path_split do
      @path_split ||= path_info.split('/')
    end

    Rack::Request.send :define_method, :dev? do
      path_split[1] == 'dev'
    end

    controller = Controller.new(env)
    controller.response.finish
  end
end
