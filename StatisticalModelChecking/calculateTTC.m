function TTC = calculateTTC(Dist, Vel, Acc)
    if (Acc == 0)
        if (Vel==0)
            TTC = 1000;
        else
            TTC = Dist/Vel;
        end
    end
    if (Acc > 0)
        TTC = (Vel-sqrt(Vel^2+2*Acc*Dist))/(-Acc);
    end
    if (Acc < 0)
        if (Vel^2+2*Acc*Dist<0)
            TTC = 1000;
        else
            TTC = (Vel-sqrt(Vel^2+2*Acc*Dist))/(-Acc);
        end
    end
end

