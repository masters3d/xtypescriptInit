class ArgumentError {}


class WordProblem{
    question:string;
    constructor(question:string) {
        this.question = question;
    }

    answer():number {
        type MathFunc = (a:number, b:number) => number
         let operans:{[key:string]:MathFunc} = { "plus" : (a:number, b:number) => {return a + b},
                        "minus" : (a:number, b:number) => {return a - b},
                        "multiplied" : (a:number, b:number) => {return a * b},
                        "divided" : (a:number, b:number) => {return a / b} }
        
        let querry = this.question.replace(/by /g, "").replace("What is ", "").replace("?","");
        let array = querry.split(" ");

        let subtotal = 0;

        if (array.length > 5 || array.length < 3 ){ throw new ArgumentError();}

        if (array.length >= 3) {
            let a = array[0];
            let b:MathFunc = operans[array[1]];
            let c = array[2];
            if (b === undefined) {throw new ArgumentError();}
            subtotal =  b(+a,+c);
        }  
        if (array.length == 5) {
            let d:MathFunc = operans[array[3]];
            let e = array[4];
            if (d === undefined) {throw new ArgumentError();}
            subtotal = d(subtotal, +e)
        } 
        return subtotal;
    }
}

export { ArgumentError, WordProblem } ;
