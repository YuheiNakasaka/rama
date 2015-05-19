require "rama"
require "thor"

module Rama
  class CLI < Thor
    desc "sprite -i MOVIE_FILE -o IMAGE_FILE", "print text"
    method_option :input, aliases: "-i", desc: "Input movie file path"
    method_option :output, aliases: "-o", desc: "Output result file"
    def sprite
      movie_file = options[:input]
      result_file = options[:output]

      timestamp = Time.now.to_i
      timestamp_image_dir = "/tmp/rama_#{timestamp}"
      Dir::mkdir(timestamp_image_dir,0777)
      system("ffmpeg -i #{movie_file} -r 12 -s qvga -f image2 #{timestamp_image_dir}/rama-original-%3d.png")
      system("convert #{timestamp_image_dir}/rama-original-*.png -quality 30 #{timestamp_image_dir}/rama-converted-%03d.jpg")
      system("convert #{timestamp_image_dir}/rama-converted-*.jpg -append #{result_file}")

      # delete all files in directory
      Dir::foreach(timestamp_image_dir) do |file|
        File.delete(timestamp_image_dir + '/' + file) if (/(\.jpg|\.png)$/ =~ file)
      end
      Dir::rmdir(timestamp_image_dir)
      say("Rama generated sprite file ~> #{result_file}", :green)
    end
  end
end