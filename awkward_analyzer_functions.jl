using AwkwardArray

function make_record_array(events)
    array = AwkwardArray.RecordArray(
        NamedTuple{(:pt, :eta, :phi, :mass, :charge, :isolation)}((
            AwkwardArray.from_iter(events.Muon_pt),
            AwkwardArray.from_iter(events.Muon_eta), 
            AwkwardArray.from_iter(events.Muon_phi), 
            AwkwardArray.from_iter(events.Muon_mass), 
            AwkwardArray.from_iter(events.Muon_charge), 
            AwkwardArray.from_iter(events.Muon_pfRelIso03_all),
        )
    ))
    return AwkwardArray.convert(array)
end

function make_record_array_from_awkward(events)
    array = AwkwardArray.RecordArray(
        NamedTuple{(:pt, :eta, :phi, :mass, :charge, :isolation)}((
            AwkwardArray.from_iter(events[:muon][:pt]),
            AwkwardArray.from_iter(events[:muon][:eta]), 
            AwkwardArray.from_iter(events[:muon][:phi]), 
            AwkwardArray.from_iter(events[:muon][:mass]), 
            AwkwardArray.from_iter(events[:muon][:charge]), 
            AwkwardArray.from_iter(events[:muon][:pfRelIso03_all]),
        )
    ))
    return AwkwardArray.convert(array)
end

four_muons = AwkwardArray.ListArray{
    AwkwardArray.Index64,
    AwkwardArray.ListArray{
        AwkwardArray.Index64,
        AwkwardArray.PrimitiveArray{Int64},
    },
}()

function find_4lep(events_leptons)

    for leptons in events_leptons
        nlep = length(leptons)
        for i0 in 1:nlep
            for i1 in (i0 + 1):nlep
                if leptons[i0][:charge] + leptons[i1][:charge] != 0
                    continue
                end
                for i2 in 1:nlep
                    for i3 in (i2 + 1):nlep
                        if length(Set([i0, i1, i2, i3])) < 4
                            continue
                        end
                        if leptons[i2][:charge] + leptons[i3][:charge] != 0
                            continue
                        end
                        
                        push!(four_muons.content.content, (i0 - 1)) # Julia is 1-based, subtract 1 for 0-based indexing
                        push!(four_muons.content.content, (i1 - 1))
                        push!(four_muons.content.content, (i2 - 1))
                        push!(four_muons.content.content, (i3 - 1))
                        AwkwardArray.end_list!(four_muons.content)
                    end
                end
            end 
        end
        AwkwardArray.end_list!(four_muons)
    end
    return four_muons
end

function invariant_mass(tree)
    array = AwkwardArray.PrmitiveArray{Float32}()
    for event in tree
        if event.nMuon == 2
            if event.Muon_charge[1] != event.Muon_charge[2]
                result = sqrt(2 * event.Muon_pt[1] * event.Muon_pt[2] *
                    (cosh(event.Muon_eta[1] - event.Muon_eta[2]) -
                        cos(event.Muon_pt[1] - event.Muon_pt[2])))
                if result > 70
                    push!(array, result)
                end
            end
        end
    end
    array
end
