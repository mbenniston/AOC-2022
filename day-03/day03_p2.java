import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class Part2 {
    public static void main(String[] args) throws IOException {
        InputStreamReader streamReader = new InputStreamReader(System.in);
        BufferedReader bufferedReader = new BufferedReader(streamReader);

        int prioritiesTotal = 0;

        ArrayList<String> threeLineBuffer = new ArrayList<>();
        threeLineBuffer.ensureCapacity(3);

        ArrayList<Character> sharedItems = new ArrayList<>();

        String line = bufferedReader.readLine();
        while(line != null)
        {
            threeLineBuffer.add(line);

            if (threeLineBuffer.size() == 3)
            {
                String firstElf = threeLineBuffer.get(0);
                String secondElf = threeLineBuffer.get(1);
                String thirdElf = threeLineBuffer.get(2);

                sharedItems.clear();

                for(char item : firstElf.toCharArray())
                {
                    if (secondElf.contains(Character.toString(item))){
                        sharedItems.add(item);
                    }
                }

                Character sharedItem = null;

                for(char item : sharedItems)
                {
                    if (thirdElf.contains(Character.toString(item))){
                        sharedItem = item;
                        break;
                    }
                }

                prioritiesTotal += getItemPriority(sharedItem);

                threeLineBuffer.clear();
            }

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
