
close all

% initialize environment params
G_acceleration=-9.8;
frame_boundary=[0,1000,0,1000];%[left,right,bottom,top]
slow_rate=1;
max_iteration=300;

% initialize objects(balls)
N_objects=10;
objects=struct;
for n_obj=1:N_objects
objects(n_obj).radius=20;
objects(n_obj).initial_pos=[100+800*rand(),900];
objects(n_obj).coefficient_of_restitution=0.5+0.3*rand();
objects(n_obj).current_pos=objects(n_obj).initial_pos;
objects(n_obj).boundary_limits=[0,1000,0,1000];%[bottom,top,left,right] % ball bouncing limit
objects(n_obj).groundhit_time=0;
objects(n_obj).bounce_count=0;
objects(n_obj).time_count=0;
objects(n_obj).motion_flag=1;
objects(n_obj).initial_v_velocity=0;
objects(n_obj).initial_h_velocity=20*rand-10;
objects(n_obj).v_velocity=0;
objects(n_obj).h_velocity=objects(n_obj).initial_h_velocity;
objects(n_obj).v_distance=0;

objects(n_obj).boundary_limits(1)=objects(n_obj).boundary_limits(1)+objects(n_obj).radius;
objects(n_obj).boundary_limits(2)=objects(n_obj).boundary_limits(2)-objects(n_obj).radius;
objects(n_obj).boundary_limits(3)=objects(n_obj).boundary_limits(3)+objects(n_obj).radius;
objects(n_obj).boundary_limits(4)=objects(n_obj).boundary_limits(4)-objects(n_obj).radius;
end

% initialize figure
f1=figure;
plot(frame_boundary(1:2),frame_boundary(3:4),'.')
hold on

% main loop starts
for count=1:max_iteration
clf;

for n_obj=1:N_objects
if objects(n_obj).motion_flag==1

    % position calculations
    objects(n_obj).v_velocity=objects(n_obj).initial_v_velocity+G_acceleration*objects(n_obj).time_count;
    objects(n_obj).v_distance=objects(n_obj).initial_v_velocity*objects(n_obj).time_count+0.5*G_acceleration*objects(n_obj).time_count*objects(n_obj).time_count;
    objects(n_obj).current_pos(2)=objects(n_obj).initial_pos(2)+objects(n_obj).v_distance;
    objects(n_obj).current_pos(1)=objects(n_obj).current_pos(1)+objects(n_obj).h_velocity;
    objects(n_obj).time_count=objects(n_obj).time_count+(1/slow_rate);

    %to check if ball reached boundary limit(bottom)
    if objects(n_obj).current_pos(2)<(objects(n_obj).boundary_limits(1))
        objects(n_obj).time_count=0;
        objects(n_obj).initial_v_velocity=objects(n_obj).v_velocity*objects(n_obj).coefficient_of_restitution;
        objects(n_obj).initial_v_velocity=-objects(n_obj).initial_v_velocity;
        objects(n_obj).h_velocity=objects(n_obj).h_velocity*objects(n_obj).coefficient_of_restitution;
        objects(n_obj).groundhit_time=objects(n_obj).time_count;
        objects(n_obj).bounce_count=objects(n_obj).bounce_count+1;
        objects(n_obj).initial_pos(2)=objects(n_obj).boundary_limits(1);
        objects(n_obj).current_pos(2)=objects(n_obj).initial_pos(2);
    end
    %to check if ball reached boundary limit(top)
    if objects(n_obj).current_pos(2)>(objects(n_obj).boundary_limits(2))
        objects(n_obj).time_count=0;
        objects(n_obj).initial_v_velocity=objects(n_obj).v_velocity*objects(n_obj).coefficient_of_restitution;
        objects(n_obj).initial_v_velocity=-objects(n_obj).initial_v_velocity;
        objects(n_obj).h_velocity=objects(n_obj).h_velocity*objects(n_obj).coefficient_of_restitution;
        objects(n_obj).bounce_count=objects(n_obj).bounce_count+1;
        objects(n_obj).initial_pos(2)=objects(n_obj).boundary_limits(2);
        objects(n_obj).current_pos(2)=objects(n_obj).initial_pos(2);
    end

    %to check if ball reached boundary limit(left)
    if objects(n_obj).current_pos(1)<=(objects(n_obj).boundary_limits(3))
        objects(n_obj).h_velocity=objects(n_obj).h_velocity*objects(n_obj).coefficient_of_restitution;
        objects(n_obj).h_velocity=-objects(n_obj).h_velocity;
        objects(n_obj).initial_pos(1)=objects(n_obj).boundary_limits(3);
        objects(n_obj).current_pos(1)=objects(n_obj).initial_pos(1);
    end
    %to check if ball reached boundary limit(right)
    if objects(n_obj).current_pos(1)>=(objects(n_obj).boundary_limits(4))
        objects(n_obj).h_velocity=objects(n_obj).h_velocity*objects(n_obj).coefficient_of_restitution;
        objects(n_obj).h_velocity=-objects(n_obj).h_velocity;
        objects(n_obj).initial_pos(1)=objects(n_obj).boundary_limits(4);
        objects(n_obj).current_pos(1)=objects(n_obj).initial_pos(1);
    end
end

end

% plot all objects
plot(frame_boundary(1:2),frame_boundary(3:4),'.')
for n_obj=1:N_objects
circle2(objects(n_obj).current_pos(1),objects(n_obj).current_pos(2),objects(n_obj).radius);
end

% to add small delay (it helps to sustain the objects on the figure)
pause(0.00001)

end


function h = circle2(x,y,r)
d = r*2;
px = x-r;
py = y-r;
h = rectangle('Position',[px py d d],'Curvature',[1,1],'FaceColor',[1 1 .5],'LineWidth',1);
% daspect([1,1,1])
end

