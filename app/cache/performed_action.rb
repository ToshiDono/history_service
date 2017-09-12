require_relative '../../config/application'
# require 'sequel/extensions/pagination'

class Cache
  class PerformedAction

    # есть ли кеш - определяем по наличию списка с ключами
    def events_list_exists?
      redis_connect { |con| con.get('cache:events:list') ? true : false }
    end

    # создает хеш и добавляет id в конец списка хешей
    def create_events_hash performed_action
      redis_connect do |con|
        con.hmset("cache:events:#{performed_action[:id]}",
                  'actor_id', performed_action[:actor_id],
                  'actor_type', performed_action[:actor_type],
                  'action', performed_action[:action],
                  'subject_id', performed_action[:subject_id],
                  'subject_type', performed_action[:subject_type],
                  'created_at', performed_action[:created_at]
        )
      end
      add_events_hash_to_list performed_action[:id]
    end

    # добавляет id(название) хеша в конец списка хешей
    def add_events_hash_to_list(id)
      redis_connect { |con| con.rprush('cache:events:list', id) }
    end

    # возвращает все события
    def events
      redis_connect do |con|
        # обойти все значения списка
        # и по значениям списка доставать хеши
        events_ids.each do  |event|
          @performed_actions << con.hgetall("cache:events:#{event}")
        end
      end
    end

    # возвращает список событий
    def events_ids
      redis_connect do |con|
        events_size = con.llen('cache:events:list')
        events_list = con.lrange(1, events_size)
        events_list
      end
    end

    # удаляет хеши и список событий
    def destroy_events_cache
      events_ids.each do |event_id|
        destroy_event(event_id)
      end
      destroy_events_list
    end

    # удаляет список событий
    def destroy_events_list
      redis_connect { |con| con.del('cache:events:list') }
    end

    # удаляет хеш
    def destroy_event(id)
      redis_connect { |con| con.del("cache:events:#{id}") }
    end

    private

    def redis_connect(&b)
      Sidekiq.redis { |con| yield(con, *args) }
    end
  end
end


performed_action = {
    id: 1000,
    actor_id: 1,
    actor_type: 'Admin',
    action: 'create',
    subject_type: 'Clinic',
    subject_id: '31'
}

cache = Cache::PerformedAction.new
puts cache.events_list_exists?