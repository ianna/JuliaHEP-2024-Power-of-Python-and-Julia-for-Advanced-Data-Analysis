using AwkwardArray

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
