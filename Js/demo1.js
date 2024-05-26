function getAllDeletedRows(){
    let remarks = [];
    let model = apex.region("bijzonderheden").widget().interactiveGrid('getViews').grid.model;
    let totalRecords = model.getTotalRecords(true);

    const deletedRecords = [];

for (let index = 0; index < totalRecords; index++) {
    let record = model.recordAt(index);
    if (record) {
        var id = model.getRecordId( record ),
        meta = model.getRecordMetadata( id );
        if(meta.deleted){
            deletedRecords.push(id)
        }
    }
}
    if (deletedRecords.length === 0) {
        return null;
    }else{
        return deletedRecords.join(":");
    }
}


function getAllRecords(){
    let remarks = [];
    let model = apex.region("bijzonderheden").widget().interactiveGrid('getViews').grid.model;
    let totalRecords = model.getTotalRecords(true);


    for (let index = 0; index < totalRecords; index++) {
        let record = model.recordAt(index); // Fixed from recordAt to getRecord
        if (record) {
            let id = model.getValue(record, "ID");
            let name = model.getValue(record, "BIJZONDERHEDEN");
            
            // Create the JSON object for each record
            remarks[index] = {
                id: isIdNull(id) ? null : id,
                name: name.trim() === "" ? null : name
            };
        }
    }
    const data = {
        remarks: remarks
    }
    console.log(data)
    return data;

}

// Execute the function
// showRecordMetadata();
// getAllRows();
