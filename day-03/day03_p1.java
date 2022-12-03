import java.io.*;

public class Part1 {

    public static void main(String[] args) throws IOException {
        InputStreamReader streamReader = new InputStreamReader(System.in);
        BufferedReader bufferedReader = new BufferedReader(streamReader);

        int prioritiesTotal = 0;

        String line = bufferedReader.readLine();
        while(line != null)
        {
            int halfLineLength = line.length() / 2;
            String leftItems = line.substring(0, halfLineLength);
            String rightItems = line.substring(halfLineLength);

            Character sharedItem = null;

            for(char item : leftItems.toCharArray())
            {
                if (rightItems.contains(Character.toString(item))){
                    sharedItem = item;
                    break;
                }
            }

            prioritiesTotal += getItemPriority(sharedItem);

            line = bufferedReader.readLine();
        }

        bufferedReader.close();
        streamReader.close();

        System.out.println(prioritiesTotal);
    }

    private static int getItemPriority(char sharedItem) {
        if(Character.isLowerCase(sharedItem))
        {
            return (sharedItem - 'a') + 1;
        }

        return 26 + (sharedItem - 'A') + 1;
    }
}
