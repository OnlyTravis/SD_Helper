import { Router } from "express";
import { FolderManager } from "../../code/folders/folder_manager.js";

const deleteImages = Router();

deleteImages.post("/deleteImages", async (req, res) => {
    try {        
        // 1. Check if all images exists.
        const images: Array<string> = JSON.parse(req.body.images);
        for (const img_path of images) {
            if (!FolderManager.fileExist(img_path)) {
                res.status(400).send({
                    message: "Invalid Request!"
                });
                return;
            }
        }
        
        // 2. Delete Image & Update Folders
        for (const img_path of images) {
            FolderManager.deleteFile(img_path);
        }

        // 3. Respond
        res.status(200).send();
    } catch {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }
});

export default deleteImages;