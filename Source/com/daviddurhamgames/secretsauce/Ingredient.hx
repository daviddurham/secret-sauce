package com.daviddurhamgames.secretsauce;

class Ingredient {
	
    public var id:Int = 0;
	public var name:String;
	
    public var salt:Int = 0;
    public var sweet:Int = 0;
    public var spicy:Int = 0;
    public var sour:Int = 0;

    public var image:String = "assets/leaf.png";
	
	public function new(_id:Int, n:String, sa:Int, sw:Int, sp:Int, so:Int, _image:String) {
		
        id = _id;
        name = n;

		salt = sa;
        sweet = sw;
        spicy = sp;
        sour = so;

        image = _image;
    }
}