# frozen_string_literal: true

module Jobs
  # This class is responsible for sending a message to a user
  class BotJob
    include SuckerPunch::Job
    workers 1

    def perform(tgram_user_data)
      depressurize_queue!
      BOT.api.send_message(
        chat_id: tgram_user_data['id'],
        text: "Hello, #{tgram_user_data['first_name']}! The current time is #{Time.now}."
      )
    end

    private

    def depressurize_queue!
      stats = SuckerPunch::Queue.stats
      worker_stats = stats.values.find { |v| v.is_a?(Hash) && v.key?('workers') }
      worker_stats &&= worker_stats['workers']
      total_jobs_in_queue = worker_stats['total']
      sleep_time = (total_jobs_in_queue * 2).clamp(1, 15).to_i
      puts "Sleeping for #{sleep_time} seconds"
      sleep(sleep_time) if worker_stats['busy']
    end
  end
end
