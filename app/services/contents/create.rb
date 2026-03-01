module Contents
  class Create
    Result = Struct.new(:success?, :content)

    def self.call(creator, params)
      content = creator.contents.build(params)
      if content.save
        Result.new(true, content)
      else
        Result.new(false, content)
      end
    end
  end
end
