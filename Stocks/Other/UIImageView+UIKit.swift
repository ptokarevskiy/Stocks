import UIKit

extension UIImageView {
    func setImage(with url: URL?) {
        guard let url = url else {
            return
        }

        DispatchQueue.global(qos: .userInteractive).async {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }

                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }

            task.resume()
        }
    }
}

//        storyImageView.setImage(with: viewModel.imageURL)
