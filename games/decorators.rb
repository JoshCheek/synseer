module Notifier
  def self.extended(klass)
    decorator = Module.new do
      # initialize with the first arg being the queue (idk if I actually like this, or would rather the class make it explicit)
      def initialize(event_queue, *rest, &block)
        @event_queue = event_queue
        super(*rest, &block)
      end
    end
    klass.const_set :NotificationDecorations, decorator # Give it a pretty inspect
    klass.prepend decorator
  end

  def notify_on(event)
    self::NotificationDecorations.module_eval do
      define_method event do |*args, &block|
        @event_queue << [event, args, :start]
        begin
          super(*args, &block)
        ensure
          @event_queue << [event, args, :stop]
        end
      end
    end
  end
end

class Store
  extend Notifier

  def initialize(db)
    @db = db
  end

  notify_on def order_purchase(user, items)
    @db.transaction do
      decrease_inventory(items)
      add_to_purchase_history(user, items)
    end
  end

  notify_on def decrease_inventory(items)
    # ...
  end

  notify_on def add_to_purchase_history(user, items)
    # ...
  end
end


class DB
  def transaction
    yield
  end
end

q  = []
Store.new(q, DB.new).order_purchase(:ryan, ["almonds", "avocados"])
q
# => [[:order_purchase, [:ryan, ["almonds", "avocados"]], :start],
#     [:decrease_inventory, [["almonds", "avocados"]], :start],
#     [:decrease_inventory, [["almonds", "avocados"]], :stop],
#     [:add_to_purchase_history, [:ryan, ["almonds", "avocados"]], :start],
#     [:add_to_purchase_history, [:ryan, ["almonds", "avocados"]], :stop],
#     [:order_purchase, [:ryan, ["almonds", "avocados"]], :stop]]
