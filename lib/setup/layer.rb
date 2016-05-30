# frozen_string_literal: true

module Kernel
  def activate(*layers)
    layers.inject { |a, e| e.onto(a) }.perfect_tasks.each do |t|
      desc(t.desc) if t.desc
      task(t.name => t.prerequisions, &t.body)
    end
  end
end

class Layer
  LayerTask = Struct.new(:name, :prerequisions, :body, :desc)

  attr_accessor :task_h

  def initialize(&body)
    @task_h = {}
    @description_buffer = nil
    body.call(self) if body
  end

  def desc(obj)
    @description_buffer = obj
  end

  def task(conf, &body)
    name = name_from_conf(conf)
    raise "task '#{name}' is already defined" if @task_h.key?(name)
    @task_h[name] = LayerTask.new(
      name,
      prerequisions_from_conf(conf),
      body,
      @description_buffer
    )
    @description_buffer = nil
  end

  def perfect_tasks
    task_h.values.select { |task| perfect?(task) }
  end

  def imperfect_tasks
    task_h.values.reject { |task| perfect?(task) }
  end

  def onto(other)
    l = Layer.new
    l.task_h = other.task_h.merge(@task_h) do |_, t1, t2|
      if t2.desc.nil? && !t1.desc.nil?
        LayerTask.new(t2.name, t2.prerequisions, t2.body, t1.desc)
      else
        t2
      end
    end
    l
  end

  private

  def name_from_conf(conf)
    name_and_prerequisions_from_conf(conf)[0]
  end

  def prerequisions_from_conf(conf)
    name_and_prerequisions_from_conf(conf)[1]
  end

  def name_and_prerequisions_from_conf(conf)
    case conf
    when String, Symbol
      [conf.to_s, []]
    when Hash
      raise 'invalid configuration' unless conf.size == 1
      prerequisions = [conf.values.first].flatten.map do |name|
        unless name.is_a?(String) || name.is_a?(Symbol)
          raise 'prerequision should be String or Symbol: ' + name.to_s
        end
        name.to_s
      end
      [conf.keys.first, prerequisions]
    else
      raise 'invalid configuration'
    end
  end

  def perfect?(task, visited = {})
    raise 'circular dependency' if visited[task.name]
    visited[task.name] = true
    res = task.prerequisions.all? do |name|
      @task_h.key?(name) && perfect?(@task_h[name], visited)
    end
    visited[task.name] = false
    res
  end
end
