<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
 
class Main extends CI_Controller {
 
    function __construct()
    {
        parent::__construct();
 
        $this->load->database();

        $this->load->library('grocery_CRUD');
        $this->load->model('login_model');
 
    }
 
    public function index()
    {
        echo "<h1>Tá funcionando</h1>";//Just an example to ensure that we get into the function
        die();
    }

   

    function checkbox($primary_key,$row)
        {
            $URL_ATUAL= "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
            $URL_ATUAL= strrev($URL_ATUAL);
                   
            $URL_ATUAL = strstr($URL_ATUAL, '/', true);
            $URL_ATUAL= strrev($URL_ATUAL);
            $ativo=$row->id;
            if ($row->caixa==1){
                return ' <form action="../main/update" method="POST"><input method="POST" type="checkbox" id='.$ativo.' name="'.$URL_ATUAL.'" table="boneca" value="0" checked onclick="teste(this)"> </form> ';

            }
            else {
                return ' <form action="../main/update" method="POST"><input method="POST" type="checkbox" id='.$ativo.' name="'.$URL_ATUAL.'" table="boneca" value="1" onclick="teste(this)"> </form> ';}
            }

    function update(){
    
    $id  = $_GET['id'];
    $table  = $_GET['table'];
    $value  = $_GET['value'];
         
    $this->db->query("Update ".$table." set caixa=".$value." where id=".$id);
    
    redirect("main/".$table, 'refresh');

}

    function senha(){
    
    $senhaAtual  = $_GET['senhaAtual'];
    $novaSenha  = $_GET['novaSenha'];
    $user =  $_GET['user'];
    

    


    $senhaAntiga=$this->db->query("SELECT password from crud_users where username='".$user."'");
    $senhaAntiga=$senhaAntiga->result_array();
    $senhaAntiga=$senhaAntiga[0]['password'];
   


    if($senhaAntiga===$senhaAtual){
        $this->db->query("UPDATE crud_users set password='".$novaSenha."' where username='".$user."'");
        echo "<script>alert('Senha alterada com sucesso! Faça o login novamente.')</script>";
        redirect("login/logout", 'refresh');
    }else{
        echo "<script>alert('A senha atual fornecida não confere com a cadastrada!')</script>";
       redirect("main/livros", 'refresh');
    }
    
   

    }



    public function mudacor($value){

        if (($value)=='IDEAL' || ($value)=='ANTES DO PRAZO'){
            return '<div style="background:#6AA84F">'.$value.'</div>';
        }
        else if (($value)=='JUSTO' || ($value)=='NO PRAZO'){
            return '<div style="background:#FFFF00">'.$value.'</div>';
        }
        else if (($value)=='CRITICO' || ($value)=='DEPOIS DO PRAZO'){
            return '<div style="background:#000000;color:white">'.$value.'</div>';
        }
        else if (($value)=='ANDAMENTO'){
            return '<div style="background:#FCE8B2">'.$value.'</div>';
        }
        else if (($value)=='ATRASADO'){
            return '<div style="background:#F4C7C3">'.$value.'</div>';
        }
        else if (($value)=='FINALIZADO'){
            return '<div style="background:#B7E1CD">'.$value.'</div>';
        }
        else if (($value)=='INICIAR'){
            return '<div style="background:#C9DAF8">'.$value.'</div>';
        }
    }

    function livros() {
    $crud = new grocery_CRUD();
    $crud->set_table('livros');
    $crud->columns('livro','autor','editor','lancamento_string','observacao','status','prazo_livro','tiragem','os','entrada_string','local_lancamento','sinopse','genero','palavra_chave','observacoes');
    
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));    
    $crud->display_as('lancamento','Lançamento'); //Mudar nome da coluna
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('observacao','Observação'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('os','OS'); //Mudar nome da coluna
    $crud->display_as('entrada_string','Entrada'); //Mudar nome da coluna
    $crud->display_as('local_lancamento','Local do Lançamento'); //Mudar nome da coluna
    $crud->display_as('genero','Gênero'); //Mudar nome da coluna
    $crud->display_as('palavra_chave','Palavras-Chave'); //Mudar nome da coluna
    $crud->display_as('observacoes','Observações'); //Mudar nome da coluna
   
    $crud -> fields('livro','autor','editor','lancamento','observacao','status','prazo_livro','tiragem','os','entrada','local_lancamento','sinopse','genero','palavra_chave','observacoes') ; //Campos do insert e update

    $crud -> set_read_fields('livro','autor','editor','lancamento_string','observacao','status','prazo_livro','tiragem','os','entrada_string','local_lancamento','sinopse','genero','palavra_chave','observacoes') ; //Campos do read

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> required_fields('lancamento','prazo_livro'); //Campos obrigatórios   
 	
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);


}

function boneca() {
    $crud = new grocery_CRUD();
    $crud->set_table('boneca');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));    
    $crud->display_as('lancamento','Lançamento'); //Mudar nome da coluna
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('observacao','Observação'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna
    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    
    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 	
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function capa() {
    $crud = new grocery_CRUD();
    $crud->set_table('capa');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    
    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 	
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function contrato() {
    $crud = new grocery_CRUD();
    $crud->set_table('contrato');
    $crud->columns('livro','lancamento_string','caixa');
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 	
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function cotejo() {
    $crud = new grocery_CRUD();
    $crud->set_table('cotejo');
    $crud->columns('livro','lancamento_string','status','prazo_livro','revisor','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> fields('revisor') ; //Campos do insert e update

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function diagramacao() {
    $crud = new grocery_CRUD();
    $crud->set_table('diagramacao');
    $crud->columns('livro','lancamento_string','status','prazo_livro','diagramador','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna
    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> fields('diagramador') ; //Campos do insert e update

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function ebook() {
    $crud = new grocery_CRUD();
    $crud->set_table('ebook');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna
    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function fechamento() {
    $crud = new grocery_CRUD();
    $crud->set_table('fechamento');
    $crud->columns('livro','lancamento_string','status','prazo_livro','finalizador','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> fields('finalizador') ; //Campos do insert e update

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function ficha() {
    $crud = new grocery_CRUD();
    $crud->set_table('ficha');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function grafica() {
    $crud = new grocery_CRUD();
    $crud->set_table('grafica');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function imprensa() {
    $crud = new grocery_CRUD();
    $crud->set_table('imprensa');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna
    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function isbn() {
    $crud = new grocery_CRUD();
    $crud->set_table('isbn');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna
    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function marketing() {
    $crud = new grocery_CRUD();
    $crud->set_table('marketing');
    $crud->columns('livro','lancamento_string','status','prazo_livro','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_edit() ; //Remove o botão editar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function preparacao() {
    $crud = new grocery_CRUD();
    $crud->set_table('preparacao');
    $crud->columns('livro','lancamento_string','status','prazo_livro','revisor','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna

    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> fields('revisor') ; //Campos do insert e update

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}

function tratamento() {
    $crud = new grocery_CRUD();
    $crud->set_table('tratamento');
    $crud->columns('livro','lancamento_string','status','prazo_livro','tratador','ilustrador','revisor','inicio_string','prazo_string','caixa','termino','termino_status');
    $crud->callback_column('prazo_livro',array($this,'mudacor'));
    $crud->callback_column('status',array($this,'mudacor'));
    $crud->callback_column('termino_status',array($this,'mudacor'));
    
    $crud->display_as('lancamento_string','Lançamento'); //Mudar nome da coluna
    $crud->display_as('status','Status (Lançamento)'); //Mudar nome da coluna
    $crud->display_as('prazo_livro','Prazo'); //Mudar nome da coluna
    $crud->display_as('inicio_string','Início'); //Mudar nome da coluna
    $crud->display_as('inicio','Início'); //Mudar nome da coluna
    $crud->display_as('prazo_string','Fim'); //Mudar nome da coluna
    $crud->display_as('termino','Entrega'); //Mudar nome da coluna
    $crud->display_as('termino_status','Status (Entrega)'); //Mudar nome da coluna
    $crud->display_as('caixa','Terminar');
    $crud->callback_column('caixa',array($this,'checkbox'));

    $crud -> fields('tratador','ilustrador','revisor') ; //Campos do insert e update

    $crud -> unset_clone() ; //Remove o botão clonar

    $crud -> unset_read() ; //Remove o botão ler

    $crud -> unset_add() ; //Remove o botão adicionar

    $crud -> unset_delete() ; //Remove o botão editar      
 
 	$crud = $this->login_model->check($crud); // Checando permissões
    $output = $crud->render();
 
    $this->_example_output($output);
}



public function users()
{

	$crud = new grocery_CRUD();
	$crud->set_table('crud_users');
	$crud->set_subject('Users');
	$crud->required_fields('username','password');
	$crud->columns('username','password','permissions');
    $this->db->where_not_in('id', '1'); // Não mostra a linha com o usuário admin
    $crud->display_as('username','Usuário'); //Mudar nome da coluna
    $crud->display_as('password','Senha'); //Mudar nome da coluna
    $crud->display_as('permissions','Permissões'); //Mudar nome da coluna
	$crud->change_field_type('password', 'password');
		

    $query=$this->db->query("SELECT name FROM crud_permissions"); 
 
        $query=$query->result_array();

        
        //for ($i=1; $i < count($query); $i++) { 
        //    $novo_array[$+1]= $query[$i]["name"];
           
       // }

     
    $crud->set_relation('permissions','crud_permissions','name');
    //$crud->field_type('permissions','dropdown', $novo_array);
            
    $crud -> unset_read() ; //Remove o botão ler

	$output = $crud->render();
	$this->_example_output($output);
	  
}


function _example_output($output = null)
 
    {
        $this->load->view('template.php',$output);    
    }
}