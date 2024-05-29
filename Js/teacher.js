
function getAllDeletedRows(igStaticId){
    let remarks = [];
    let model = apex.region(igStaticId).widget().interactiveGrid('getViews').grid.model;
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


function getAllRecords(igStaticId, arrayColumn) {
    let remarks = [];
    let model = apex.region(igStaticId).widget().interactiveGrid('getViews').grid.model;
    let totalRecords = model.getTotalRecords(true);

    for (let index = 0; index < totalRecords; index++) {
        let record = model.getRecord(index); // Fixed from recordAt to getRecord
        if (record) {
            let recordData = {};
            arrayColumn.forEach(column => {
                let value = model.getValue(record, column);
                recordData[column.toLowerCase()] = (value === "" || value === null || value === undefined) ? null : value;
            });
            remarks.push(recordData);
        }
    }

    const data = {
        remarks: remarks
    };

    console.log(data);
    return data;
}