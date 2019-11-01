<?php
class Login_model  extends CI_Model  {

	public function __construct()
	{
		parent::__construct();
		$this->load->database();
		$this->load->helper('form');
		$this->load->helper('url');
		$this->load->library('session');
	}
	
	/* CHECK LOGIN, return BOOL */
	public function isLogged(){
		if(null !== $this->session->userdata('loginStatus')){
			return 1;
		}
		return 0;
	}
	
	/* RETURN PERMISSION FIELD (the one you save into the session, if no permission was set so the username is returned */
	public function permission(){
		$data = json_decode($this->session->userdata('loginStatus'));
		return $data->permissions;
	}/*aliases*/public function permissions(){return $this->permission();} public function getPermission(){return $this->permission();} public function getPermissions(){return $this->permission();
	}
	
	// Return the id of the current logged user
	public function id(){
		$data = json_decode($this->session->userdata('loginStatus'));
		return $data->id;
	}
	
	// Return the username of the current logged user
	public function name(){
		$data = json_decode($this->session->userdata('loginStatus'));
		return $data->username;
	}/*aliases*/public function username(){return $this->name();}
	
	//Return the specified field into the crud_users database of the current logged user
	public function getField($field){
		return $this->db->query("SELECT $field FROM crud_users WHERE id = ".$this->id())->row()->$field;
	}

	//botão de logoff
	public function botaosair(){
		echo '<a  href="'. site_url('login/logout').'"><div type="button" class="button button1">Sair</div></a>';
	}
	
	
	/* LOGOUT the current user */
	public function logout($redirect=true){
		$this->session->sess_destroy();
		if($redirect) redirect("/login");
	}


	/* FROM HERE THE PERMISSION MANAGEMENT SYSTEM */
	/*             JUST GROCERYCRUD               */
	// check the permission of a user for a specific action in a specific table
	// return a boolean
	public function extractPermission($what,$permission=false,$table=false){
		/*
		ID  RL  RS  A  E  D
		x   x   x   x  x  x
		*/
		if(is_bool($permission)){
			$query = $this->db->query("SELECT permissions FROM crud_permissions WHERE id = ".$this->permission());
			$permission = json_decode($query->row()->permissions,true);
			if(!$table){ echo "You need to pass a table to 'this->login_model->extractPermission()' as third parameter to use the current logged user permissions!";die;}
			if(isset($permission[$table])){
				$permission = $permission[$table];
			}else{
				$permission = 100000;
			}
		}else{
			if(is_array($permission) && isset($permission[$table])){
				$permission = $permission[$table];
			}else{
				if(!is_numeric($permission)) $permission = 100000;
			}
		}
		$return = 0;
		if($what == "ID"||$what=="idonly"){
			if($permission[0].""==""){
				$return = 0;
			}else{
				$return = ($permission[0]?0:1);
			}
		}
		if($what == 2||$what == "RL"||$what=="readlist") $return = $permission[1];
		if($what == 3||$what == "RS"||$what=="readsingle") $return = $permission[2];
		if($what == 4||$what == "A"||$what=="add") $return = $permission[3];
		if($what == 5||$what == "E"||$what=="edit") $return = $permission[4];
		if($what == 6||$what == "D"||$what=="delete") $return = $permission[5];
		return $return;
	}
	
	//Check if perm allow to see IDOnly or All
	public function IDOnly($table,$permission=true){
		return $this->extractPermission("ID",$permission,$table);		
	}
	//Check if perm allow to see grid list or not
	public function canSeeList($table,$permission=true){
		return $this->extractPermission("RL",$permission,$table);		
	}
	//Check if perm allow to see the single view of the records
	public function canSeeSingle($table,$permission=true){
		return $this->extractPermission("RS",$permission,$table);		
	}
	//Check if perm allow to add a record
	public function canAdd($table,$permission=true){
		return $this->extractPermission("A",$permission,$table);		
	}
	//Check if perm allow to edit a record
	public function canEdit($table,$permission=true){
		return $this->extractPermission("E",$permission,$table);		
	}
	//Check if perm allow to delete a record
	public function canDelete($table,$permission=true){
		return $this->extractPermission("D",$permission,$table);		
	}
	
	//The function that MUST be used to filter the CRUD table based on the permissions
	public function check($crud,$author=false){
		$state = unserialize(
			preg_replace(
				'/^O:\d+:"[^"]++"/', 
				'O:'.strlen("portapipe").':"portapipe"',
				serialize($crud)
			)
		);
		$state = json_encode((array)$state);
		$state2 = strpos($state,'basic_db_table":"');
		$state = str_replace('basic_db_table":"','',substr($state, $state2));
		$state2 = strpos($state,'"');
		$table = substr($state, 0, $state2);
		if(!$this->extractPermission("RL",false,$table)) $crud->unset_list();
		if(!$this->extractPermission("RS",false,$table)) $crud->unset_read();
		if(!$this->extractPermission("D",false,$table)) $crud->unset_delete();
		if(!$this->extractPermission("A",false,$table)) $crud->unset_add();
		if(!$this->extractPermission("E",false,$table)) $crud->unset_edit();
		if(!$this->extractPermission("D",false,$table)) $crud->unset_delete();
		
		if($author) $crud->where($author,$this->id());
		
		return $crud;
	}

		public function topnavDinamico(){
			$query = $this->db->query("SELECT permissions FROM crud_permissions WHERE id = ".$this->permission());
			
			
			$permissoes = json_decode($query->row()->permissions,true);


			$permissoes= (array_keys($permissoes));
			$a=count($permissoes);

			$URL_ATUAL= "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
               // $URL_ATUAL= strrev($URL_ATUAL);
                    
              //  $URL_ATUAL = strstr($URL_ATUAL, '/', true);
               // $URL_ATUAL= strrev($URL_ATUAL);




			for ($i=0; $i<$a; $i++){
                $pagina=$permissoes[$i];
                   
    			

				if($pagina=="livros"){
                	if( strstr($URL_ATUAL, 'livros') ){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Livros</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Livros</a>';}
                }
               

                else if($pagina=="grafica"){
                	if(strstr($URL_ATUAL, 'grafica')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Produção Gráfica';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Produção Gráfica</a>';

                	}

                	
                }
                
                else if($pagina=="crud_users"){
                	if(strstr($URL_ATUAL, 'users')){
                	echo '<a class="active" href="'. site_url('main/users').'"'.$pagina.'>Usuários</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/users').'"'.$pagina.'>Usuários</a>';}
                }

                                

                else if($pagina=="cotejo"){
                	if(strstr($URL_ATUAL, 'cotejo')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Cotejo (Revisão)</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Cotejo (Revisão)</a>';}
                }
                
                else if($pagina=="preparacao"){
                	if(strstr($URL_ATUAL, 'preparacao')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Preparação (Revisão)</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Preparação (Revisão)</a>';}
                }

                else if($pagina=="ebook"){
                	if(strstr($URL_ATUAL, 'ebook')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>E-Book</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>E-Book</a>';}
                }

                else if($pagina=="ficha"){
                	if(strstr($URL_ATUAL, 'ficha')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Ficha Catalográfica</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Ficha Catalográfica</a>';}
                }

                else if($pagina=="boneca"){
                	if(strstr($URL_ATUAL, 'boneca')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Aprovação Boneca</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Aprovação Boneca</a>';}
                }

                else if($pagina=="isbn"){
                	if(strstr($URL_ATUAL, 'isbn')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>ISBN</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>ISBN</a>';}
                }

                else if($pagina=="tratamento"){
                	if(strstr($URL_ATUAL, 'tratamento')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Tratamento/Ilustração</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Tratamento/Ilustração</a>';}
                }

				else if($pagina=="crud_permissions"){
                	if(strstr($URL_ATUAL, 'manage_permissions')){
                	echo '<a  class = "active" href="'. site_url('login/manage_permissions').'"'.$pagina.'>Permissões</a>';
                }
                	else {
                		echo '<a  href="'. site_url('login/manage_permissions').'"'.$pagina.'>Permissões</a>';}
                }
                

                else if($pagina=="capa"){
                	if(strstr($URL_ATUAL, 'capa')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Capa</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Capa</a>';}
                }
                else if($pagina=="contrato"){
                	if(strstr($URL_ATUAL, 'contrato')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Contrato</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Contrato</a>';}
                }

                else if($pagina=="diagramacao"){
                	if(strstr($URL_ATUAL, 'diagramacao')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Diagramação</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Diagramação</a>';}
                }

                else if($pagina=="fechamento"){
                	if(strstr($URL_ATUAL, 'fechamento')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Fechamento</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Fechamento</a>';}
                }

                else if($pagina=="imprensa"){
                	if(strstr($URL_ATUAL, 'imprensa')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Imprensa</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Imprensa</a>';}
                }

                

                else if($pagina=="marketing"){
                	if(strstr($URL_ATUAL, 'marketing')){
                	echo '<a class="active" href="'. site_url('main/'.$pagina).'"'.$pagina.'>Marketing</a>';
                }
                	else {
                		echo '<a  href="'. site_url('main/'.$pagina).'"'.$pagina.'>Marketing</a>';}
                }

            }
						
			
 	}

}
