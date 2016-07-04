module ApplicationHelper
  def random_background_image
    images = [
      "background-Jason-James.png",
      "background-Luz-Adriana-Villa.png",
      "background-Leander-Arkenau.png",
      "background-Michael-Mandiberg.png"
    ]

    image_num = rand(images.length)
    "assets/#{images[image_num]}"
  end
end
