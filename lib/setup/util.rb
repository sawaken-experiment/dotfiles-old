def home(path)
  ENV['HOME'] + '/' + path
end

def which(bin)
  res = `which #{bin}`
  res == '' ? nil : res
end

def dotfile_status(dotfile_name)
  dotfile_path_home = home(dotfile_name)
  dotfile_path_here = File.expand_path(dotfile_name)
  raise unless dotfile_path_here
  if File.exist?(dotfile_path_home)
    link_dest = `readlink #{dotfile_path_home}`.chomp
    if link_dest == dotfile_path_here
      {:status => :ok, :desc => 'linked from dotfiles'}
    elsif link_dest == ''
      {:status => :warning, :desc => 'entity (the file is not a symlink)'}
    else
      {:status => :warning, :desc => "linked from the other (#{link_dest})"}
    end
  else
    {:status => :error, :desc => 'unlinked (the file does not exist)'}
  end
end

def dotfile_status_colorized(dotfile_name)
  status = dotfile_status(dotfile_name)
  case status[:status]
  when :ok
    green(status[:desc])
  when :warning
    yellow(status[:desc])
  when :error
    red(status[:desc])
  end
end

def shift_path(path)
  paths = ENV['PATH'].split(':')
  paths.push(path)
  ENV['PATH'] = paths.uniq.join(':')
end

def red(txt)
  "\e[31m" + txt + "\e[m"
end

def green(txt)
  "\e[32m" + txt + "\e[m"
end

def yellow(txt)
  "\e[33m" + txt + "\e[m"
end

# SHELLの環境変数に依存せずにanyenvを実行する
# 注意) anyenvを利用するためには、SHELLが以下の条件を満たす必要が有る
#        * anyenvのパスが通っていること
#        * anyenv initが実行されていること
def ash(command, &proc)
  shift_path("#{ENV['HOME']}/.anyenv/bin")
  sh('eval "$(anyenv init -)"; ' + command, &proc)
end

def asho(command)
  shift_path("#{ENV['HOME']}/.anyenv/bin")
  `eval "$(anyenv init -)"; #{command}`
end

def shq(command)
  sh command + ' | cat'
end

class Layer
  attr_reader :name, :desc, :tasks

  def initialize(name, parent_layers)
    @name = name
    @desc = nil
    @tasks = {}
    parent_layers.each do |layer|
      tasks.merge!(layer.tasks){ raise 'task name duplicated' }
    end
  end

  def set_desc(desc)
    @desc = desc
  end

  def get_desc
    ret = @desc
    @desc = nil
    return ret
  end

  def define_task(name, body, prereqs)
    raise 'task name duplicate' if @tasks.has_key?(name)
    @tasks[name] = LayerTask.new(name, body, get_desc, prereqs)
  end

  def override_task(name, body, prereqs)
    raise 'override target unexists' unless @tasks.has_key?(name)
    desc = get_desc || @tasks[name].desc
    @tasks[name] = LayerTask.new(name, body, desc, prereqs)
  end
end

class LayerTask
  attr_reader :name, :body, :desc, :prereqs
  def initialize(name, body, desc, prereqs)
    @name = name
    @body = body
    @desc = desc
    @prereqs = prereqs
  end
end

class LayerManager
  attr_reader :current_layer, :layers

  def initialize
    @current_layer = nil
    @layers = {}
  end

  def begin_layer(layer)
    @current_layer = layer
  end

  def end_layer
    @layers[@current_layer.name] = @current_layer
    @current_layer = nil
  end
end

class Param
  attr_reader :name, :list
  def initialize(obj)
    case obj
    when Hash
      case obj.size
      when 1
        @name = obj.keys.first.to_s
        @list = [obj.values.first].flatten.map(&:to_s)
      else
        raise
      end
    else
      @name = obj.to_s
      @list = []
    end
  end
end

def layer(param, &block)
  @layer_manager ||= LayerManager.new
  param = Param.new(param)
  if @layer_manager.layers.has_key?(param.name)
    layer = @layer_manager.layers[param.name]
  else
    parent_layers = param.list.map do |lname|
      unless @layer_manager.layers.has_key?(lname)
        raise "undefined layer: #{lname}"
      end
      @layer_manager.layers[lname]
    end
    layer = Layer.new(param.name, parent_layers)
  end
  @layer_manager.begin_layer(layer)
  block.call if block
  @layer_manager.end_layer
end

def ldesc(desc)
  layer = @layer_manager.current_layer
  layer.set_desc(desc)
end

def ltask(param, &body)
  param = Param.new(param)
  layer = @layer_manager.current_layer
  layer.define_task(param.name, body, param.list)
end

def override_task(param, &body)
  param = Param.new(param)
  layer = @layer_manager.current_layer
  layer.override_task(param.name, body, param.list)
end

def activate(layer_name)
  layer = @layer_manager.layers[layer_name.to_s]
  layer.tasks.values.each do |t|
    t.prereqs.each do |pt|
      unless layer.tasks.has_key?(pt)
        raise "undefined prerequision for #{t.name}: #{pt}"
      end
    end
    desc(t.desc) if t.desc
    task(t.name => t.prereqs, &t.body)
  end
end
