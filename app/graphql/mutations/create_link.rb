module Mutations
  class CreateLink < BaseMutation
    field :link, Types::LinkType, null: false

    argument :description, String, required: true
    argument :url, String, required: true

    def resolve (description:, url: )
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

    end
    
  end
end
