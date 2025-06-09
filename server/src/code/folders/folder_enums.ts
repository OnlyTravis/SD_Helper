export enum FileTypes {
    Image,
    JSON,
    Others,
}
export interface FileObject {
    file_name: string,
    file_type: FileTypes
}
export interface FolderObject {
    parent: string,
    folder_name: string,
    folder_path: string,
    folders: Array<FolderObject>,
    files: Array<FileObject>
}