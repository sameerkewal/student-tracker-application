
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

function upsertStudent() {

    // Get all the records from the IG
    const allRecords = getAllRecords();

// Call the AJAX process to save the data
    apex.server.process(
        "SAVE_IG_DATA",
        {
            x01: apex.item("P10_ID").getValue(),  // Properly call getValue()
            x02: JSON.stringify(allRecords),
            x03: apex.item("P10_VOORNAAM").getValue(),
            x04: apex.item("P10_ACHTERNAAM").getValue(),
            x05: apex.item("P10_GEBOORTEDATUM").getValue(),
            x06: apex.item("P10_KLAS").getValue(),
            x07: apex.item("P10_GESLACHT").getValue(),
            x08: apex.item("P10_HOOFD_ADRES").getValue(),
            x09: apex.item("P10_ALTERNATIEF_ADRES").getValue(),
            x10: apex.item("P10_CARETAKER").getValue(),
            x11: apex.item("P10_JAAR_VAN_INSCHRIJVING").getValue(),
            x12: apex.item("P10_JAAR_VAN_AFSCHRIJVING").getValue(),
            x13: apex.item("P10_SCHOOL_VAN_AFKOMST").getValue(),
            x14: getAllDeletedRows()
        }
    ).done(function (data) {
        console.log(data);
        console.log("Received Data: ", JSON.stringify(data, null, 2));

        if (data && data.errors && data.errors.length > 0) {
            apex.message.clearErrors();
            data.errors.forEach(function (errorMsg) {
                apex.message.showErrors([
                    {
                        type: "error",
                        location: ["inline", "page"],
                        pageItem: errorMsg.item,
                        message: errorMsg.msg
                    }
                ]);
            });
        } else {
            apex.page.submit({
                validate: false,
                request: data.action
            })
        }
    })
        .fail(function (error) {
            console.log(error)
            apex.message.clearErrors();
            apex.message.showErrors([
                {
                    type: "error",
                    location: "page",
                    message: error
                }
            ]);
        });
}