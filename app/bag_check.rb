class BagCheck
  def self.call(cgmp_batch)
    /53-\w+/.match(cgmp_batch.codeprod).nil?
  end
end
