function [ind]=distance_sort(label_names)

label_location=label_center_coord(label_names);

for ilabel1=1:1
    
    coord1=label_location(ilabel1,:);
    
    for ilabel2=2:length(label_names)
        
        coord2=label_location(ilabel2,:);
        
        x=coord1(1)-coord2(1);
        y=coord1(2)-coord2(2);
        z=coord1(3)-coord2(3);
        
        distance(ilabel2)=sqrt((x)^2+(y)^2+(z)^2);
        
    end
    
end

[val,ind]=sort(distance);