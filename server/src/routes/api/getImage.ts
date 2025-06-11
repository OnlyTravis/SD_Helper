import { Router } from "express";
import { FolderManager } from "../../code/folders/folder_manager.js";
import { FileTypes } from "../../code/folders/folder_enums.js";
import sharp from "sharp";

const getImage = Router();

enum ImageSize {
    Original = -1,
    Small = 200,
}
getImage.get("/getImage", async (req, res) => {
    if (!req.query || !req.query.image || typeof req.query.image !== "string") {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }
    let size = ImageSize.Original;
    if (req.query.size === "s") size = ImageSize.Small;

    const file_path = req.query.image;
    const file_type = FolderManager.getFileType(file_path);
    if (file_type !== FileTypes.Image) {
        res.status(400).send({
            message: "File Type not allowed!"
        });
        return;
    }

    const actual_path = FolderManager.getActualPath(file_path);
    if (size === ImageSize.Original) {
        res.status(200).sendFile(actual_path);
        return;
    } else if (size === ImageSize.Small) {
        const meta = await sharp(actual_path).metadata();
        if (meta.width >= meta.height) {
            const buffer = await sharp(actual_path).resize(200).toBuffer();
            res.status(200).send(buffer);
        } else {
            const buffer = await sharp(actual_path).resize(null, 200).toBuffer();
            res.status(200).send(buffer);
        }
    }
});

export default getImage;