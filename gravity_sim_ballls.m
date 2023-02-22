
close all

G_acceleration=9.8;
frame_boundary=[0,1000,0,1000];
framerate=5;
total_time=350;
N_objects=10;
objects=struct;
for n_obj=1:N_objects
%if object is rectangle
% objects(n_obj).height_width=[50,60];
%if object is circle
objects(n_obj).center_pos=2;%if object is circle
objects(n_obj).radius=20;
%followings needed for all objects
objects(n_obj).initial_pos=[500,1000];
objects(n_obj).mass=2;
objects(n_obj).horizontal_velocity=1+10*rand();
objects(n_obj).coefficient_of_restitution=0.1+0.6*rand();
objects(n_obj).freefall_flag=1;
objects(n_obj).current_pos=objects(n_obj).initial_pos;
objects(n_obj).groundhit_time=0;
objects(n_obj).bounce_count=0;
objects(n_obj).counter_1=0;
objects(n_obj).initial_loop_count=0;
objects(n_obj).velocity_falling=0;
objects(n_obj).distance_fallen=0;
objects(n_obj).velocity_bouncing=0;
objects(n_obj).distance_bounced=0;
objects(n_obj).motion_flag=1;
end

f1=figure;
plot(frame_boundary(1:2),frame_boundary(3:4),'.')
hold on

for time=1:total_time
clf;

for n_obj=1:N_objects
if objects(n_obj).motion_flag==1
if objects(n_obj).freefall_flag==1
    % -------------freefall stage----------
    objects(n_obj).counter_1=objects(n_obj).counter_1+1;
    objects(n_obj).velocity_falling=(G_acceleration/framerate)*objects(n_obj).counter_1;
    objects(n_obj).distance_fallen=0.5*objects(n_obj).velocity_falling*objects(n_obj).counter_1;
    current_Y_pos=objects(n_obj).initial_pos(2)-objects(n_obj).distance_fallen;
    % to check if falling ball reaches ground position
    if current_Y_pos<0
        current_Y_pos=0;
        objects(n_obj).freefall_flag=0;
        objects(n_obj).groundhit_time=time;
        objects(n_obj).velocity_bouncing=objects(n_obj).velocity_falling;
        counter_new=round(objects(n_obj).counter_1*log(1+10*objects(n_obj).coefficient_of_restitution)/log(11));
%         counter_new=round(objects(n_obj).counter_1*objects(n_obj).coefficient_of_restitution);
        objects(n_obj).counter_1=counter_new;
    end
    objects(n_obj).current_pos(2)=current_Y_pos;
    % add horizontal movement
    if objects(n_obj).bounce_count>0
        objects(n_obj).current_pos(1)=objects(n_obj).current_pos(1)+objects(n_obj).horizontal_velocity;
    end
    % to check if object reach the horizontal right boundary
    if (objects(n_obj).current_pos(1)+objects(n_obj).radius)>=frame_boundary(4)
        objects(n_obj).current_pos(1)=frame_boundary(4)-objects(n_obj).radius;
        objects(n_obj).horizontal_velocity=objects(n_obj).horizontal_velocity*(-1);%to inverse the sign
    end
    % to check if object reach the horizontal left boundary
    if (objects(n_obj).current_pos(1)-objects(n_obj).radius)<=frame_boundary(3)
        objects(n_obj).current_pos(1)=frame_boundary(3)+objects(n_obj).radius;
        objects(n_obj).horizontal_velocity=objects(n_obj).horizontal_velocity*(-1);%to inverse the sign
    end
else
    objects(n_obj).counter_1=objects(n_obj).counter_1-1;
    % ------------bouncing stage-----------
    objects(n_obj).velocity_bouncing=(G_acceleration/framerate)*objects(n_obj).counter_1;
    objects(n_obj).distance_bounced=0.5*objects(n_obj).velocity_bouncing*objects(n_obj).counter_1;
    objects(n_obj).distance_bounced=objects(n_obj).initial_pos(2)-objects(n_obj).distance_bounced;
    current_Y_pos=objects(n_obj).distance_bounced*objects(n_obj).coefficient_of_restitution;
    if current_Y_pos<0
        current_Y_pos=0;
    end
    objects(n_obj).current_pos(2)=current_Y_pos;
    % add horizontal movement
    objects(n_obj).current_pos(1)=objects(n_obj).current_pos(1)+objects(n_obj).horizontal_velocity;
    % to check if object reach the horizontal right boundary
    if (objects(n_obj).current_pos(1)+objects(n_obj).radius)>=frame_boundary(4)
        objects(n_obj).current_pos(1)=frame_boundary(4)-objects(n_obj).radius;
        objects(n_obj).horizontal_velocity=objects(n_obj).horizontal_velocity*(-1);%to inverse the sign
    end
    % to check if object reach the horizontal left boundary
    if (objects(n_obj).current_pos(1)-objects(n_obj).radius)<=frame_boundary(3)
        objects(n_obj).current_pos(1)=frame_boundary(3)+objects(n_obj).radius;
        objects(n_obj).horizontal_velocity=objects(n_obj).horizontal_velocity*(-1);%to inverse the sign
    end
    % to check if bouncing ball reaches maximum vertical position
    if objects(n_obj).velocity_bouncing<0
        objects(n_obj).velocity_bouncing=0;
        objects(n_obj).bounce_count=objects(n_obj).bounce_count+1;
        objects(n_obj).freefall_flag=1;
        if objects(n_obj).current_pos(2)<1e-5
            objects(n_obj).initial_pos(2)=0;
            objects(n_obj).motion_flag=0;
        else
            objects(n_obj).initial_pos=objects(n_obj).current_pos;
        end
    end
end

end
% disp(objects(n_obj).current_pos)
end
plot(frame_boundary(1:2),frame_boundary(3:4),'.')
for n_obj=1:N_objects
% rectangle('Position',[objects(n_obj).current_pos,objects(n_obj).height_width]);
circle2(objects(n_obj).current_pos(1),objects(n_obj).current_pos(2)+objects(n_obj).radius,objects(n_obj).radius);
end
pause(0.00001)

end


function h = circle2(x,y,r)
d = r*2;
px = x-r;
py = y-r;
h = rectangle('Position',[px py d d],'Curvature',[1,1],'FaceColor',[1 1 .5],'LineWidth',1);
% daspect([1,1,1])
end

