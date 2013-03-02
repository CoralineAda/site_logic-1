class Ckeditor::Picture < Ckeditor::AttachmentFile
	def url_content
	  url(:content)
	end

	def url_thumb
	  url(:thumb)
	end
end