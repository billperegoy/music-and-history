module ApplicationHelper
  def random_background_image
    images = [
      "01-background.png",
      "02-background.png",
      "03-background.png",
      "04-background.png",
      "05-background.png",
      "07-background.png",
      "08-background.png",
      "09-background.png",
      "10-background.png",
      "11-background.png",
      "12-background.png",
      "13-background.png",
      "14-background.png",
      "15-background.png",
      "16-background.png",
      "17-background.png",
      "18-background.png",
      "19-background.png",
      "20-background.png"
    ]

    image_num = rand(images.length)
    asset_path(images[image_num])
  end
end
