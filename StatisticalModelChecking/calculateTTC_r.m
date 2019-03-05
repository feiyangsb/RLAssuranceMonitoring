function TTC_r = calculateTTC_r(Dist, Vel, Acc)
    if (Acc == 0)
        TTC_r = Vel/Dist;
    end
    if (Acc > 0)
        TTC_r = (-Acc)/(Vel-sqrt(Vel^2+2*Acc*Dist));
    end
    if (Acc < 0)
        if (Vel^2+2*Acc*Dist<0)
            TTC_r = 0;
        else
            TTC_r = (-Acc)/(Vel-sqrt(Vel^2+2*Acc*Dist));
        end
    end
end

