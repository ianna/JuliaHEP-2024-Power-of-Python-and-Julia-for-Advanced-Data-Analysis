using AwkwardArray

function get_electrons_as_record_array(events)
    array = AwkwardArray.RecordArray(
        NamedTuple{(:pt, :eta, :phi, :mass, :charge, :isolation)}((
            AwkwardArray.from_iter(events.Electron_pt),
            AwkwardArray.from_iter(events.Electron_eta), 
            AwkwardArray.from_iter(events.Electron_phi), 
            AwkwardArray.from_iter(events.Electron_mass), 
            AwkwardArray.from_iter(events.Electron_charge), 
            AwkwardArray.from_iter(events.Electron_pfRelIso03_all),
        )
    ))
    return AwkwardArray.convert(array)
end
