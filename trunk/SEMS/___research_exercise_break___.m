%% RESEARCH EXCERCISE BREAK!

ex = ceil(rand*10);
clc
switch ex
   case 1
      N = ceil(rand*30);
      disp([num2str(N),' Pushups!'])
      exercise.pushups = [exercise.pushups; N now];
   case 2
      N = ceil(rand*30);
      disp([num2str(N),' Leg Lifts!'])
      exercise.leglifts = [exercise.leglifts; N now];
   case 3
      N = 10*ceil(rand*5);
      disp(['Horse Stance, count: ',num2str(N)])
      exercise.horsestance = [exercise.horsestance; N now];
   case 4
      N = ceil(rand*30);
      disp(['Plank knee to elbow, count: ',num2str(N), ' both sides']) 
      exercise.kneetoelbow = [exercise.kneetoelbow; N now];
   case 5
      N = ceil(rand*30);
      disp(['Stretch kick, count: ',num2str(N), ' both sides']) 
      exercise.stretchkick = [exercise.stretchkick; N now];
   case 6
      N = ceil(rand*20);
      disp(['Down/Up Dog, count: ',num2str(N), ' both sides'])
      exercise.downupdog = [exercise.downupdog; N now];
   case 7
      N = ceil(rand*50);
      disp(['Splits stretch, count: ',num2str(N)])    
      exercise.splits = [exercise.splits; N now];
   case 8
      N = ceil(rand*40);
      disp(['Sitting forward/backward stretch, count : ',num2str(N)]) 
      exercise.sitstretch = [exercise.sitstretch; N now];
   case 9
      N = ceil(rand*50);
      disp(['Balance on ball, count: ',num2str(N)])   
      exercise.sitstretch = [exercise.sitstretch; N now];
   case 10
      N = ceil(rand*50);
      disp(['Freestyle (follow your hear), count: ',num2str(N)])
      exercise.freestyle = [exercise.freestyle; N now];
end

clear N ex