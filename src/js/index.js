/*
 * Copyright (c) - All Rights Reserved.
 */

class Grid {
    constructor(rows, cols, grid) {
        this.rows = rows
        this.cols = cols
        this.grid = grid || this.init(rows, cols)
                
    }
    init(rows, cols) {
        return [
            ..."0".repeat(rows)]
            .map(
                () => [..."0".repeat(cols)].map(() => new Cell())
            )  
    }
    map2D(f) {
        return new Grid(this.rows, this.cols
            , this.grid.map(
                (row, i) => row.map(
                    (cell, j) => f({ row: i, col: j }, cell)
                )
            )
        )
    }
    neighbors(row, col) {
        return [ [-1, -1]
               , [-1,  0]
               , [-1, +1]
               , [ 0, +1]
               , [+1, +1]
               , [+1,  0]
               , [+1, -1]
               , [ 0, -1]
            ].map(
                ([row_, col_]) =>
                    [(row + row_) === -1 ? this.rows - 1 : (row + row_) % this.rows
                    ,(col + col_) === -1 ? this.cols - 1 : (col + col_) % this.cols
                    ]
            ).map(
                ([row_, col_]) => this.grid[row_][col_]
            )
    }
    randomize() {
        return this
            .map2D(
                () => new Cell(Random.boolean())
            )
    }
    evenOnly(orientation) {
        return this
            .map2D(
                (position, cell) => new Cell(position[orientation] % 2 === 0, cell.age + 1)
            )
    }
    atPositions(positions) {
        return this
            .map2D(
                (position, cell) => new Cell(position in positions, cell.age + 1)
            )
    }
    transition(randomness = RandomEventPer.Ik) {
        return this
            .map2D(
                ({ row, col }, cell) => 
                cell.transition(this.neighbors(row, col), randomness)
            )
    }
    draw() {
        const gridHTML =
            this.map2D((_, cell) => cell.show()).grid.map(row => row.join("")).join("")
            
        $("#grid")
            .css("height", this.rows * 2 + "px")
            .css("width", this.cols * 2 + "px")
            .empty()
            .append(gridHTML)

        return gridHTML
    }
}

const RandomEventPer =      
    {I    : 0
    ,Io   : 1       
    ,IO0  : 2
    ,Ik   : 3
    ,Iok  : 4
    ,IO0k : 5
    ,Im   : 6
    }

class Cell {
    constructor(alive = false, age = 0) {
        this.alive = alive 
        this.age = age
    }
    transition(neighbors, randomness = RandomEventPer.Ik) {

        const aliveNeighbors =
            neighbors.filter(cell => cell.alive)

        let alive =
            this.alive ?
                aliveNeighbors.length > 1 && aliveNeighbors.length <= 3 :
                aliveNeighbors.length === 3

        return new Cell(Random.intInRange(1, 10 ** randomness) === 1 ? !alive : alive, +this.age + +alive)
    }
    show() {
        const opacity =
            this.alive ? +this.age / +(10 ** (this.age.toString().length)) : +0.0

        return `<div style="opacity: ${opacity};" class="cell ${this.alive ? 'alive' : 'dead'}"></div>`
    }
}

let grid = new Grid(100, 100).evenOnly("row")

function nextState () {
        
    if ($(this).text() === "Start") {
        $(this).text("Next")
    }
    else {
        grid = grid.transition(RandomEventPer.IO0k)
    }

    grid.draw()
}


// EVENTS
//
$("#startOrNext").on("click", nextState)

setInterval(nextState, 1000)