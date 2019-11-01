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

    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script>



 
    
    
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
    
<div class="container">
        
        <!-- Button to Open the Modal -->
        <button type="button" class="button button1" data-toggle="modal" data-target="#myModal">
            Alterar senha
        </button>

        <!-- The Modal -->
        <div class="modal" id="myModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <!-- Modal Header -->
                    <div class="modal-header">
                        <h3 class="modal-title" align="center">Alterar senha</h3>
                        
                    </div>

                    <!-- Modal body -->
                    <div class="modal-body">
                        <form  method="POST">
                        	<br>
                        <label for="pass">Senha atual:  </label><input type="password" id="senhaAtual" name="<?php echo $this->login_model->name();?>" autocomplete="off" /><br><br>
                        <label for="pass">Nova Senha:  </label><input type="password" id="novaSenha" name="novaSenha" autocomplete="off" /><br><br>
                        <label for="pass">Confirme a senha: </label><input type="password" id="confirmeSenha" name="confirmeSenha" autocomplete="off" /><br><br>
                        
                        <div class="modal-footer">
                        <button type="button" class= "botaoalterar" data-dismiss="modal" onclick="salvar()" >Alterar</button>
                        <button type="button" class="botaofechar" data-dismiss="modal">Fechar</button>
                    </div>
                    </form>
                    </div>

                    <!-- Modal footer -->
                    

                </div>
            </div>
        </div>

    </div>
 <script>
    function salvar(el){
            
            var confirmeSenha= document.getElementById('confirmeSenha').value;
            var senhaAtual = document.getElementById('senhaAtual').value;
            var novaSenha = document.getElementById('novaSenha').value;
            var user= document.getElementById('senhaAtual').name;
            

            

            if (novaSenha == confirmeSenha)
                {
                  window.location.replace('http://localhost/editora/index.php/main/senha?senhaAtual='+senhaAtual+'&novaSenha='+novaSenha+'&user='+user);
                }
                  else
                {
                   alert('As senhas não conferem!');
                }
         
          }

  </script>




    <?php $this->login_model->botaosair();?>
 
  <!-- Copyright -->

</footer>
<!-- End of Footer -->
</html>
 