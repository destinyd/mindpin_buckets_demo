class Folder
  include MindpinBuckets::BucketMethods
  act_as_bucket collect: :photo
end
