# Lecture5 - IMAGE REGISTRATION METHODS (ELASTIX)

## Preparation

1. Run Git bash.
2. Set username by: `$ git config --global user.name "name_of_your_GitHub_profile"`
3. Set email by: `$ git config --global user.email "email@example.com"`
4. Select some MAIN folder with write permision.
5. Clone the **Lecture5** repository from GitHub by: `$ git clone https://github.com/MPC-AB2/Lecture5.git`
6. In the MAIN folder should be new folder **Lecture5**.
7. In the **Lecture5** folder create subfolder **NAME_OF_YOUR_TEAM**.
8. Run Git bash in **Lecture5** folder (should be *main* branch active).
9. Create a new branch for your team by: `$ git checkout -b NAME_OF_YOUR_TEAM`
10. Check that  *NAME_OF_YOUR_TEAM* branch is active.
11. Continue to the task...

## Tasks to do

### Task 1 - Elementary script for image registration using Elastix
1. Download the zip file with Elastix software version 5.0.1 for Windows x64 from [here](https://github.com/SuperElastix/elastix/releases).
2. Extract all files from zip file into the created subfolder **elastix** in main folder **Lecture5**.
3. Download the data in a zip file from [here](https://www.vut.cz/www_base/vutdisk.php?i=286020a49b). Extract the content of the zip folder into **Lecture5** folder. It contains three mat files (*dataX.mat*), each containing *fixed* (reference) and *moving* image. In the first task we will be working with *data1.mat* only.
4. Elastix needs the input in the *mhd/raw* files. Create fuction *mat2raw.m* to save variable to *mhd/raw* file:
   * the inputs will be 2D matrix, save-path and file name,
   * function writes the variable into *.raw* and *.mhd* format (no output).
5. Create an alternative function *mat2rawMASK.m* to write a binary image; the same inputs/outputs as before.
6. Create function *raw2mat.m* to read *mhd/raw* file:
   * the input will be a path to the *.mhd* file to be loaded,
   * the output argument will be a variable.
7. Create a script for registration:
   * load example images from *data1.mat*,
   * write images from *fixed* and *moving* variables into *.raw* and *.mhd* files by *mat2raw.m* function,
   * run image registration using Elastix by command line execution in Matlab,
   * read registered image from *mhd/raw* file by *raw2mat.m* function.
9. Perform geometrical transformation of the image via Transformix using command line execution in Matlab.
10. Change the transformix command to save also the deformation field.
11. Perform rigid and affine registration of images from data1.mat and set the parametric files properly to get visually optimal results.

### Task 2 - Using binary masks in (AFFINE geom. transf.)
1. Create a copy of your registration script from Task 1.
2. Try to use it to register the images from *data2.mat* file.
3. Modify your script to use a binary mask for elimination zero pixels of background.
4. Perform registration of images from *data2.mat* and set the parametric files properly to get visually optimal results.

### Task 3 - Design of registration approaches leading to correction of breathing movement - Challenge
1. Create a copy of your registration script from Task 2.
2. Load *data3.mat* file, which contains single pairs of 2D lung CT images.
3. Design the registration approach which will correct a breathing movement in inhale and exhale phase (The pipeline can consist several registrations with different geometrical transformations and/or parameters, including pyramidal approach.).
12. Use the provided MATLAB function for the evaluation of the results. The function *Eval_Lung2D.p* called as:
`[evalLung, evalOther] = Eval_Lung2D(registered)`,
has the following inputs and outputs:
  * registered - variable of registered image (uint8, same size as moving image)
  * evalLung - efficiency of registration of lung tissue (in range <-100, +100>, higher is better),
  * evalOther - efficiency of registration of other tissues (in range <-100, +100>, higher is better).
6. **Push** your program implementations into GitHub repository **Lecture5** using the **branch of your team** (stage changed -> fill commit message -> sign off -> commit -> push -> select *NAME_OF_YOUR_TEAM* branch -> push -> manager-core -> web browser -> fill your credentials).
8. Submit *.tiff* image of the best-obtained result of your registration approach and fill in the corresponding results into a shared [Excel table](https://docs.google.com/spreadsheets/d/1ZLWh8O1HYGq7U62asCGflhpPCPrQu6ll/edit?usp=sharing&ouid=112211468254352441667&rtpof=true&sd=true). The evaluation of results from each team will be presented at the end of the lecture.
