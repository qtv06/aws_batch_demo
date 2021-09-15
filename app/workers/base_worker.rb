class BaseWorker
  class << self
    def submit(*args)
      aws_batch_client.submit_job(job_config(*args))
    end

    private

      def aws_batch_client
        @_aws_batch_client ||= Aws::Batch::Client.new(
          region:            ENV["AWS_REGION"],
          access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
        )
      end

      def job_config(*args)
        job_config = {
          job_name: job_name,
          job_queue: job_queue,
          job_definition: job_definition,
          container_overrides: {
            command: generate_command(*args),
          }
        }
      end

      def job_definition
        "aws_batch_demo_job_defination"
      end

      def job_name
        self.name
      end

      def job_queue
        "aws_batch_demo_job_queue"
      end

      def generate_command(*args)
        string_params = format_params_to_string(*args)
        ["bundle", "exec", "rails", "r", "#{self.name}.new.perform(#{string_params})"]
      end

      def format_params_to_string(*args)
        string_params = ""
        args.each do |param|
          string_params += if param.is_a?(String)
                            "\"#{param}\","
                          else
                            "#{param},"
                          end
        end
        string_params.slice!(-1, 1)
        string_params
      end
  end
end