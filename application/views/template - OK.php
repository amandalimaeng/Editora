<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="utf-8" />
 
<?php 
foreach($css_files as $file): ?>
    <link type="text/css" rel="stylesheet" href="<?php echo $file; ?>" />
 
<?php endforeach; ?>
<?php foreach($js_files as $file): ?>
 
    <script src="<?php echo $file; ?>"></script>
<?php endforeach; ?>
 
<style type='text/css'>
body
{
    font-family: Arial;
    font-size: 20px;
}
a {
    color: black;
    text-decoration: none;
    font-size: 15px;

}

footer {
        height: 	50px;
        background: #eee;
        font-size: 20	px;
        color :black;
        font-weight: bold;
        padding-top: 20px;
        padding-bottom: 10px;
      }

.button {
  background-color: #861F1F; 
  float:right;
  border: none;
  color: white;
  padding: 8px 16px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  margin-right: 5px;
  font-size: 15px; 
  cursor: pointer;
}

.button1 {
  background-color: white; 
  color: black; 
}

.button1:hover {
  background-color: #861F1F;
  color: white;
}

</style>
</head>
<body>
    <script>
          function teste(el){
                       

            var id= document.getElementById(el.id).id;
            var value= document.getElementById(el.id).value;
            var table= document.getElementById(el.id).name;

            window.location.replace('http://olinda/editora/index.php/main/update?id='+id+'&value='+value+'&table='+table);
            
            }

        

    </script>

   



 
    
    
    <div class="topnav">
    	<a class="logo"></a>

        
        
        <?php $this->login_model->topnavDinamico();?>
         
    
 
    </div>

<!-- End of header-->     
    <div>
        <?php echo $output; ?>
 
    </div>
</body>
<!-- Beginning footer -->
<footer>
 
 
  
    Bem-vindo: <?php echo $this->login_model->name(); ?>
    


    <?php $this->login_model->botaosair();?>
 
  <!-- Copyright -->

</footer>
<!-- End of Footer -->
</html>
 