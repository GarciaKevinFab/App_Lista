import express from 'express';
import { v2 as cloudinary } from 'cloudinary';
import Product from '../models/Products.js';

const router = express.Router();

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Ruta para subir una imagen a Cloudinary y obtener su URL
router.post('/upload', async (req, res) => {
    try {
      const result = await cloudinary.uploader.upload(req.body.imageBase64, {
        folder: 'carpeta_en_cloudinary', // Opcional: especifica una carpeta en Cloudinary
      });
  
      const imageUrl = result.secure_url; // URL de la imagen en Cloudinary
  
      res.json({ imageUrl });
    } catch (err) {
      res.status(500).send(err.message);
    }
  });
  
  // Rutas CRUD
  router.get('/', async (req, res) => {
      try {
          const products = await Product.find();
          res.json(products);
      } catch (err) {
          res.status(500).send(err.message);
      }
  });
  
  
  //Create Product
  router.post('/', async (req, res) => {
      try {
          // Asegúrate de que req.body incluye la URL de la imagen de Cloudinary
          const product = new Product(req.body);
          await product.save();
          res.status(201).json(product);
      } catch (err) {
          res.status(500).send(err.message);
      }
  });
  
  router.put('/:id', async (req, res) => {
      try {
          const product = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
          res.json(product);
      } catch (err) {
          res.status(500).send(err.message);
      }
  });
  
  router.delete('/:id', async (req, res) => {
      try {
          await Product.findByIdAndDelete(req.params.id);
          res.status(204).send();
      } catch (err) {
          res.status(500).send(err.message);
      }
  });

  export default router;
