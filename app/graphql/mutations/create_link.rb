module Mutations
  class CreateLink < BaseMutation
    field :link, Types::LinkType, null: false

    argument :description, String, required: true
    argument :url, String, required: true

    def resolve (description: nil, url: nil)
      link = Link.new(description: description, url: url, user: context[:current_user])
      
      if (link.save)
        { 
          link: link,
          errors: []
         } else {
           link: nil,
           errors: link.errors.full_messages
         }
      end

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")

    end
    
  end
end
