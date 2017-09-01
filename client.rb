module Mastodon
  module REST
    class Client
      def create_status(text, visibility = nil, in_reply_to_id = nil, media_ids = [])
        perform_request_with_object(:post, '/api/v1/statuses', array_param(:media_ids, media_ids).merge(status: text, visibility: visibility, in_reply_to_id: in_reply_to_id), Mastodon::Status)
      end
    end
  end
end
