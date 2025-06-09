import { Router } from "express";
import { FolderManager } from "../code/folders/folder_manager.js";

const apiRouter = Router();

apiRouter.post("/getFolder", (req, res) => {
    if (!req.query || !req.query.folder || typeof req.query.folder !== "string") {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }

    const folder = FolderManager.getFolder(req.query.folder);
    if (!folder) {
        res.status(400).send({
            message: "Folder not found!"
        });
        return;
    }
    res.status(200).json(folder);
});

apiRouter.post("/getFile", (req, res) => {
    if (!req.query || !req.query.file || typeof req.query.file !== "string") {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }

    const file_path = req.query.file;
    const file_type = FolderManager.getFileType(file_path);
    if (!FolderManager.isAllowedFileType(file_type)) {
        res.status(400).send({
            message: "File Type not allowed!"
        });
        return;
    }

    const actual_path = FolderManager.getActualPath(file_path);
    res.status(200).sendFile(actual_path);
});

export default apiRouter;