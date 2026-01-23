// const fs = require("fs")
// const sharp = require("sharp")


// class BaseImgEncodeUtil {
//   static encodeBase64(filePath) {
//     let imgBase64str = null;
//     try {
//       const data = fs.readFileSync(filePath)
//       if (data)
//         imgBase64str = data.toString('base64')
//     } catch (err) {
//       // console.error(err)
//     }
//     return imgBase64str
//   }

//   static createZoomImage(originalFilePath, resizedFilePath, newWidth, quality) {
//     if (quality > 1 || quality < 0) {
//       throw new Error('Quality must be between 0 and 1');
//     }

//     // Read the image using sharp
//     sharp(originalFilePath)
//       .metadata()
//       .then((metadata) => {
//         const { width, height } = metadata;
//         let resizedWidth = 0;
//         let resizedHeight = 0;

//         // Determine new dimensions while maintaining aspect ratio
//         if (width > height) {
//           resizedWidth = newWidth;
//           resizedHeight = Math.round((newWidth * height) / width);
//         } else {
//           resizedHeight = newWidth;
//           resizedWidth = Math.round((newWidth * width) / height);
//         }

//         // Resize image and adjust quality
//         sharp(originalFilePath)
//           .resize(resizedWidth, resizedHeight)
//           .jpeg({ quality: Math.round(quality * 100) }) // quality is from 0 to 100
//           .toFile(resizedFilePath, (err, info) => {
//             if (err) {
//               console.error('Error processing image:', err);
//               return;
//             }
//             console.log('Resized image saved:', info);
//           });
//       })
//       .catch((err) => {
//         console.error('Error reading image metadata:', err);
//       });
//   }
// }

// module.exports = { BaseImgEncodeUtil }