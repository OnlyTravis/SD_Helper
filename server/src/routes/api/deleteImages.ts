import { Router } from "express";

const deleteImages = Router();

deleteImages.post("/deleteImages", async (req, res) => {
    if (!req.body || !req.body.images) {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }
    console.log(req.body.images);
});

export default deleteImages;