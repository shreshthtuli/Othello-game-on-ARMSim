import java.util.*;
import java.io.*;

public class Othello_Board
{	
	private char[][] board;
	private int black_score;
	private int white_score;
	public ArrayList<int[]> allowed_pos = new ArrayList<int[]>();

	public Othello_Board()
	{
		board = new char[][]{{'_','_','_','_','_','_','_','_'},{'_','_','_','_','_','_','_','_'},{'_','_','_','*','_','_','_','_'},{'_','_','*','W','B','_','_','_'},{'_','_','_','B','W','*','_','_'},{'_','_','_','_','*','_','_','_'},{'_','_','_','_','_','_','_','_'},{'_','_','_','_','_','_','_','_'},};
		black_score = 2;
		white_score = 2;

		int[] all_pos = new int[2];

		all_pos = new int[]{2,3};
		allowed_pos.add(all_pos);
		all_pos = new int[]{3,2};
		allowed_pos.add(all_pos);
		all_pos = new int[]{4,5};
		allowed_pos.add(all_pos);
		all_pos = new int[]{5,4};
		allowed_pos.add(all_pos);
	}

	public void play(int player, int pos_x, int pos_y)
	{
		char isPlayer;
		char isOpponent;
		int i;
		int j;

		if(player == 1)
		{
			isPlayer = 'W';
			isOpponent = 'B';
			white_score++;
		}
		else
		{
			isPlayer = 'B';
			isOpponent = 'W';
			black_score++;
		}

		board[pos_x][pos_y] = isPlayer;
		i = pos_x;
		j = pos_y;

		if(i >= 1 && j >= 1)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, 1,1,0,0,8,8);

        if(i >= 1)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, 1,0,0,-1,8,8);
        
		if(i >= 1 && j <= 6)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, 1,-1,0,-1,8,7);

		if(j >= 1)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, 0,1,-1,0,8,8);

		if(j <= 6)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, 0,-1,-1,-1,8,7);

		if(i <= 6 && j >= 1)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, -1,1,-1,0,7,8);

        if(i <= 6)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, -1,0,0,-1,7,8);

		if(i <= 6 && j <= 6)
			play_moves(board, pos_x, pos_y, isPlayer, isOpponent, player, -1,-1,-1,-1,7,7);

	}

	public void play_moves(char[][] board, int pos_x, int pos_y, char isPlayer, char isOpponent, int player, int k, int l, int a, int b, int c, int d)
	{

		int i;
		int j;
        i = pos_x;
		j = pos_y;

		if(board[i - k][j - l] == isOpponent) 
			{	
				i-=k;
				j-=l;
            	while(i > a && j > b && i < c && j < d) 
            	{
            		i-=k;
            		j-=l;
            		if(board[i][j] != isOpponent)
            		{
            			break;
            		}
            	}
            	if(i >= a && j >= b && i <= c && j <= d)
            	{
            		if(board[i][j] == isPlayer)
            		{
            			while((i != pos_x - k || i == pos_x) && (j != pos_y - l || j == pos_y))
            			{
            				i+=k;
            				j+=l;
            				board[i][j] = isPlayer;
            				if(player == 1)
							{
								black_score--;
								white_score++;
							}
							else
							{
								black_score++;
								white_score--;
							}
            			}
            		}
            	}
        	}

        i = pos_x;
		j = pos_y;
	}

	public void updateAllowPos(int player)
	{
		for(int[] pos : allowed_pos)
		{
			if(board[pos[0]][pos[1]] == '*')
			{
				board[pos[0]][pos[1]] = '_';
			}
		}
		allowed_pos = new ArrayList<int[]>();

		char isPlayer;
		char isOpponent;
		int i;
		int j;

		if(player == 1)
		{
			isPlayer = 'W';
			isOpponent = 'B';
		}
		else
		{
			isPlayer = 'B';
			isOpponent = 'W';
		}

		for(int a = 0; a < 8; a++)
		{
			for(int b = 0; b < 8; b++)
			{
				if(board[a][b] == isOpponent)
				{	
					i = a;
					j = b;

					if(i >= 1 && j >= 1)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, 1,1,-1,-1,7,7);
					
					if(i >= 1)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, 1,0,-1,-1,7,8);

					if(i >= 1 && j <= 6)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, 1,-1,-1,0,7,8);

					if(j >= 1)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, 0,1,-1,-1,8,7);

					if(j <= 6)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, 0,-1,-1,0,8,8);

					if(i <= 6 && j >= 1)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, -1,1,0,-1,8,7);

					if(i <= 6)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, -1,0,0,-1,8,8);

					if(i <= 6 && j <= 6)
						update_pos(board, a, b, isPlayer, isOpponent, allowed_pos, -1,-1,0,0,8,8);
				}
			}
		}
	}

	public void update_pos(char[][] board, int a_, int b_, char isPlayer, char isOpponent, ArrayList allowed_pos, int k, int l, int a, int b, int c, int d)
	{
		int i;
		int j;
		i = a_;
		j = b_;

		if(board[i - k][j - l] == '_') 
		{	
			i+=k;
			j+=l;
	    	while(i > a && j > b && i < c && j < d)
	    	{
	    		if(board[i][j] != isOpponent)
	    		{
	    			break;
	    		}
	    		i+=k;
	    		j+=l;
	    		
	    	}
	    	
	    	if(i >= a && j >= b && i <= c && j <= d)
	    	{	
	    		if(board[i][j] == isPlayer)
	    		{
	    			allowed_pos.add(new int[]{a_ - k,b_ - l});
	    			board[a_ - k][b_ - l] = '*';
	    		}
	    	}
		}
	   
	    i = a_;
		j = b_;
	}

	public void displayScene(int count)
	{	

		System.out.print(" $");

		for(int i = 1; i < 9; i++)
		{
			System.out.print(" " + i + " ");
		}
		System.out.println();

		for(int i = 0; i < 8 ; i++)
		{	
			System.out.print(" " + (i + 1));
			for(int j = 0; j < 8; j++)
			{	
				System.out.print(" " + board[i][j] + " ");
			}
			System.out.println();
		}
		System.out.println();

		if(count == 59)
		{
			if(black_score > white_score)
			{
				System.out.println(" Black Wins");
			}
			else if(black_score < white_score)
			{
				System.out.println(" White Wins");
			}
			else
			{
				System.out.println(" Ooopss! It's a Draw!");
			}

			System.out.println();
			System.out.println(" Black Final Score: " + black_score);
			System.out.println(" White Final Score: " + white_score);
		}
		else
		{
			System.out.println(" Black Score: " + black_score);
			System.out.println(" White Score: " + white_score);
		}
	}

	public static void main (String[] args) throws java.lang.Exception
	{	
		Othello_Board Game = new Othello_Board();

		Scanner s = new Scanner(System.in);

		Game.displayScene(0);

		for(int count = 0; count < 60; count++)
		{
			
			int player = (count) % 2;

			Game.updateAllowPos(player);

			if(Game.allowed_pos.isEmpty() || Game.black_score==0 || Game.white_score==0)
			{
				count = 59;
				Game.displayScene(count);
				break;
			}

			if(player == 0)
			{	
				System.out.println();
				System.out.println(" Black Turn:");
			}
			else
			{
				System.out.println();
				System.out.println(" White Turn:");
			}

			int pos_x = s.nextInt() - 1;
			int pos_y = s.nextInt() - 1;
			int check_valid = 0;
			System.out.println();

			for(int[] all_pos:Game.allowed_pos)
			{
				if(Arrays.equals(all_pos,new int[]{pos_x, pos_y}))
				{
					check_valid = 1;
				}
			}

			while(!(check_valid == 1))
			{
				System.out.println("Enter a Valid Move!");
				pos_x = s.nextInt() - 1;
				pos_y = s.nextInt() - 1;
				System.out.println();

				for(int[] all_pos:Game.allowed_pos)
				{
					if(Arrays.equals(all_pos,new int[]{pos_x, pos_y}))
					{
						check_valid = 1;
					}
				}
			}

			Game.play(player, pos_x, pos_y);
			Game.updateAllowPos(1 - player);
			if(Game.allowed_pos.isEmpty())
			{
				count--;
				Game.updateAllowPos(player);
			}
			Game.displayScene(count);
		}
	}
}